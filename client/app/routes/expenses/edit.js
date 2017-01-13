import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {
    model(params) {
        return this.get('store').findRecord('expense', params.expense_id);
    },

    setupController(controller, model) {
        this._super(...arguments);
        controller.set('expense-date', model.get('date').toString());
    }
});
