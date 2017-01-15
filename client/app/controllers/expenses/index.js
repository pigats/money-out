import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),
    'show-filter': true,

    'daily-average-expense': Ember.computed('model.meta.total-expense', 'model.meta.number-of-days', function() {
        return +this.get('model.meta.total-expense')/+this.get('model.meta.number-of-days');
    }),

    _filter(query) {
        query.userId = this.get('me').get('user.id');
        this.get('store').query('expense', query).then(model => this.set('model', model));
    },

    actions: {
        deleteExpense(expense) {
            if(window.confirm(`Are you sure you want to delete ${expense.get('description')}?`)) {
                this.decrementProperty('model.meta.total-expense', expense.get('amount'));
                expense.destroyRecord();
            }
        },

        filter(query = {}) {
            Ember.run.debounce(
                this,
                '_filter',
                query,
                500
            );
        },

        toggleFilter() {
            this.toggleProperty('show-filter');
        }

    }
});
