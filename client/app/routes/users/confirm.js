import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
    me: Ember.inject.service('current-user'),

    beforeModel() {
        this._super(...arguments);
        if(this.get('me').get('user.confirmed?')) {
            this.transitionTo('expenses.index');
        }
    },

    model() {
        return this.get('me').get('user');
    }

});
