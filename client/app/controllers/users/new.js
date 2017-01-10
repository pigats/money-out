import Ember from 'ember';

export default Ember.Controller.extend({
    session: Ember.inject.service('session'),

    actions: {
        createUser() {
            this.set('model.email', this.get('email'));
            this.set('model.password', this.get('password'));

            this.get('model').save().then(() =>
                this.get('session').authenticate('authenticator:jwt', this.get('model.email'), this.get('model.password'))
            );
        }
    }
});
