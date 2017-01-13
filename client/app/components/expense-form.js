import Ember from 'ember';

export default Ember.Component.extend({
    actions: {
        setDate(date) {
            this.set('expense.date', date);
        }
    }
});
