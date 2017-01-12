import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),

    actions: {
        deleteExpense(expense) {
            if(window.confirm(`Are you sure you want to delete ${expense.get('description')}?`)) {
                expense.destroyRecord();
            }
        },

        filterUser(userId) {
            if(!Ember.isEmpty(userId)) {
                this.get('store').query('expense', { userId }).then(model =>this.set('model.expenses', model));
            } else {
                this.get('store').findAll('expense').then(model => this.set('model.expenses', model));
            }
        }
    }
});
