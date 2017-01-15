import Ember from 'ember';

export default Ember.Component.extend({
    actions: {
        deleteExpense(expense) {
            this.sendAction('delete', expense);
        }
    }
});
