import Ember from 'ember';

export default Ember.Component.extend({
    session: Ember.inject.service('session'),

    actions: {
        login() {
            this.get('session').authenticate('authenticator:jwt', this.get('email'), this.get('password'))
                .catch(error => {
                    if(error.status === 404) {
                        this.set('error', 'Wrong credentials');
                    } else {
                        throw error;
                    }
                });
        }
    }
});
