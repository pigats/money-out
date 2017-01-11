import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),

    'daily-average-expense': Ember.computed('model.meta.total-expense', 'model.meta.number-of-days', function() {
        return +this.get('model.meta.total-expense')/+this.get('model.meta.number-of-days');
    }),

    init() {
    },

    actions: {
        deleteExpense(expense) {
            if(window.confirm(`Are you sure you want to delete ${expense.get('description')}?`)) {
                this.decrementProperty('model.meta.total-expense', expense.get('amount'));
                expense.destroyRecord();
            }
        },

        filter() {
            const description = this.get('description');
            const date = { from: this.get('dateFrom'), to: this.get('dateTo') };
            const amount = { from: this.get('amountFrom'), to: this.get('amountTo') };
            const query = { userId: this.get('me').user.get('id') };

            if(description) {
                query.description = description;
            }
            if(date.from && date.to) {
                query.date = date;
            }
            if(amount.from && amount.to) {
                query.amount = amount;
            }
            this.get('store').query('expense', query).then((model) => this.set('model', model));
        }
    }
});
