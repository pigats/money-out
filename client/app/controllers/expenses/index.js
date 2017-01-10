import Ember from 'ember';

export default Ember.Controller.extend({
    actions: {
        deleteExpense(expense) {
            if(window.confirm(`Are you sure you want to delete ${expense.get('description')}?`)) {
                expense.destroyRecord();
            }
        }
    }
});
