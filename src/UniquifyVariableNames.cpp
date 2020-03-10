#include "UniquifyVariableNames.h"
#include "IRMutator.h"
#include <sstream>

namespace Halide {
namespace Internal {

using std::map;
using std::string;
using std::vector;

namespace {

class UniquifyVariableNames : public IRMutator {

    using IRMutator::visit;

    map<string, int> vars;

    void push_name(const string &s) {
        if (vars.find(s) == vars.end()) {
            vars[s] = 0;
        } else {
            vars[s]++;
        }
    }

    string get_name(string s) {
        if (vars.find(s) == vars.end()) {
            return s;
        } else if (vars[s] == 0) {
            return s;
        } else {
            std::ostringstream oss;
            oss << s << "_" << vars[s];
            return oss.str();
        }
    }

    void pop_name(const string &s) {
        vars[s]--;
    }

    template<typename LetOrLetStmt>
    auto visit_let(const LetOrLetStmt *op) -> decltype(op->body) {
        struct Frame {
            const LetOrLetStmt *op;
            Expr value;
            string new_name;
        };

        vector<Frame> frames;
        decltype(op->body) result;
        while (op) {
            Expr val = mutate(op->value);
            push_name(op->name);
            frames.push_back({op, val, get_name(op->name)});
            result = op->body;
            op = result.template as<LetOrLetStmt>();
        }

        result = mutate(result);

        for (auto it = frames.rbegin(); it != frames.rend(); it++) {
            pop_name(it->op->name);
            if (it->new_name == it->op->name &&
                result.same_as(it->op->body) &&
                it->op->value.same_as(it->value)) {
                result = it->op;
            } else {
                result = LetOrLetStmt::make(it->new_name, it->value, result);
            }
        }

        return result;
    }

    Stmt visit(const LetStmt *op) override {
        return visit_let(op);
    }

    Expr visit(const Let *op) override {
        return visit_let(op);
    }

    Stmt visit(const For *op) override {
        Expr min = mutate(op->min);
        Expr extent = mutate(op->extent);
        push_name(op->name);
        string new_name = get_name(op->name);
        Stmt body = mutate(op->body);
        pop_name(op->name);

        if (new_name == op->name &&
            body.same_as(op->body) &&
            min.same_as(op->min) &&
            extent.same_as(op->extent)) {
            return op;
        } else {
            return For::make(new_name, min, extent, op->for_type, op->device_api, body);
        }
    }

    Expr visit(const Variable *op) override {
        string new_name = get_name(op->name);
        if (op->name != new_name) {
            return Variable::make(op->type, new_name);
        } else {
            return op;
        }
    }

public:
    UniquifyVariableNames(map<string, int> &&free_vars)
        : vars(free_vars) {
    }
};

class FindFreeVars : public IRVisitor {
    Scope<> vars;

    using IRVisitor::visit;

    template<typename LetOrLetStmt>
    void visit_let(const LetOrLetStmt *op) {
        vector<ScopedBinding<>> frames;
        decltype(op->body) body;
        while (op) {
            op->value.accept(this);
            frames.emplace_back(vars, op->name);
            body = op->body;
            op = body.template as<LetOrLetStmt>();
        }

        body.accept(this);
    }

    void visit(const LetStmt *op) override {
        visit_let(op);
    }

    void visit(const Let *op) override {
        visit_let(op);
    }

    void visit(const For *op) override {
        op->min.accept(this);
        op->extent.accept(this);
        {
            ScopedBinding<> bind(vars, op->name);
            op->body.accept(this);
        }
    }

    void visit(const Variable *op) override {
        if (!vars.contains(op->name)) {
            free_vars[op->name] = 0;
        }
    }

public:
    map<string, int> free_vars;
};

}  // namespace

Stmt uniquify_variable_names(const Stmt &s) {
    FindFreeVars finder;
    s.accept(&finder);
    UniquifyVariableNames u(std::move(finder.free_vars));
    return u.mutate(s);
}

}  // namespace Internal
}  // namespace Halide
