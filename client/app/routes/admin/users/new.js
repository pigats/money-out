import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
    me: Ember.inject.service('current-user'),

    beforeModel() {
        this._super(...arguments);
        if(!this.get('me').get('user.is-user-admin')) {
            this.transitionTo('expenses.index');
        }
    },

    model() {
        return this.get('store').createRecord('user');
    },

    actions: {
        willTransition() {
            this.get('currentModel').rollbackAttributes();
            this._super(...arguments);
        }
    }


});
