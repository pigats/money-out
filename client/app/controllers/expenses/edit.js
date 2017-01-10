import Ember from 'ember';

export default Ember.Controller.extend({
    actions: {
        updateExpense(expense) {
            expense.save().then(() => this.transitionToRoute('expenses'));
        }
    }
});
