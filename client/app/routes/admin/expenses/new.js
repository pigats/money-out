import Ember from 'ember';

export default Ember.Route.extend({
    me: Ember.inject.service('current-user'),

    beforeModel() {
        this._super(...arguments);
        if(!this.get('me').get('user.is-admin')) {
            this.transitionTo('expenses.index');
        }
    },

    model() {
        return Ember.RSVP.hash({
            expense: this.get('store').createRecord('expense', { user: this.get('me').get('user') }),
            users: this.get('store').findAll('user')
        });
    },

});
