import Ember from 'ember';

export default Ember.Controller.extend({
    actions: {
        setUser(id) {
            this.get('store').findRecord('user', id).then(user =>
                this.get('model.expense').set('user', user)
            );
        },

        createExpense(params) {
            this.set('model.expense.date', new Date(params.get('date')));
            this.set('model.expense.description', params.get('description'));
            this.set('model.expense.amount', params.get('amount'));
            this.set('model.expense.comment', params.get('comment'));

            this.get('model.expense').save().then(() => this.transitionToRoute('admin.expenses.index'));
        }
    }
});
