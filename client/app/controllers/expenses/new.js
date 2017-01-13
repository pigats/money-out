import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),

    actions: {
        createExpense(expense) {
            expense.set('user', this.get('me').get('user'));
            expense.save().then(() => this.transitionToRoute('expenses.index'));
        }
    }
});
