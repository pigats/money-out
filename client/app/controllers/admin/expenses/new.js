import Ember from 'ember';

export default Ember.Controller.extend({
    actions: {
        setUser(id) {
            this.get('store').findRecord('user', id).then(user =>
                this.get('model.expense').set('user', user)
            );
        },

        createExpense(expense) {
            expense.set('date', new Date(expense.get('date')));
            expense.save().then(() => this.transitionToRoute('admin.expenses.index'));
        }
    }
});
