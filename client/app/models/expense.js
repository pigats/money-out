import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
    date: DS.attr('date'),
    description: DS.attr('string'),
    amount: DS.attr('number'),
    comment: DS.attr('string'),
    user: DS.belongsTo('user', {async: true}),

    amountInDollars: Ember.computed('amount', function() {
        return `${this.get('amount').toFixed(2)} $`
    })
});
