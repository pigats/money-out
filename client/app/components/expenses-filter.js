import Ember from 'ember';

export default Ember.Component.extend({
    'human-date-from': '1 week ago',
    'human-date-to': 'today',

    didRender() {
        this.change();
    },

    change() {
        const description = this.get('description');
        const date = { from: this.get('dateFrom'), to: this.get('dateTo') };
        const amount = { from: this.get('amountFrom'), to: this.get('amountTo') };
        const query = {};

        const statuses = {
            on: 'isEnabled',
            off: 'isDisabled'
        };

        if(!Ember.isEmpty(description) && description.length >= 3) {
            query.description = description;
            this.set('description-status', statuses.on);
        } else {
            this.set('description-status', statuses.off);
        }

        if(date.from && date.to && date.from.valueOf() < date.to.valueOf()) {
            query.date = date;
            this.set('date-status', statuses.on);
        } else {
            this.set('date-status', statuses.off);
        }
        if(amount.from && amount.to) {
            query.amount = amount;
            this.set('amount-status', statuses.on);
        } else {
            this.set('amount-status', statuses.off);
        }

        this.sendAction('action', query);
    },

    actions: {
        setDateFrom(date) {
            this.set('dateFrom', date);
        },
        setDateTo(date) {
            this.set('dateTo', date);
        }
    }
});
