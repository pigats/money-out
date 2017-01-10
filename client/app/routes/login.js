import Ember from 'ember';

export default Ember.Route.extend({
    setupController() {
        this._super(...arguments);
        this.controllerFor('application').set('isLogin', true);
    },

    actions: {
        willTransition() {
            this.controllerFor('application').set('isLogin', false);
            this._super(...arguments);
        }
    }
});
