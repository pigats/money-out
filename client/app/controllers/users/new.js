import Ember from 'ember';

export default Ember.Controller.extend({
    session: Ember.inject.service('session'),

    actions: {
        createUser(user) {
            user.save().then(() =>
                this.get('session').authenticate('authenticator:jwt', this.get('model.email'), this.get('model.password'))
            );
        }
    }
});
