import Ember from 'ember';

export default Ember.Component.extend({
    init() {
        this._super(...arguments);
        this._convertToDate();
    },

    _convertToDate() {
        let date = chrono.parseDate(this.get('human-value'));
        if(Ember.isEmpty(date)) {
            date = undefined;
        }

        this.set('date', date);
        this.get('on-change')(date);
    },

    actions: {
        convertToDate() {
            Ember.run.debounce(
                this,
                '_convertToDate',
                200
            );
        }
    }
});
