import Ember from 'ember';

export default Ember.Controller.extend({
    session: Ember.inject.service('session'),

    actions: {
        updateUser(params) {
            this.set('model.email', params.get('email'));

            if(!Ember.isEmpty(params.get('password'))) {
                this.set('model.password', params.get('password'));
            }

            this.get('model').save().then(() =>
                this.transitionToRoute('expenses.index')
            );
        }
    }
});
