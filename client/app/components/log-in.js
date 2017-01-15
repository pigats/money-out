import Ember from 'ember';

export default Ember.Component.extend({
    session: Ember.inject.service('session'),

    init() {
        this._super(...arguments);
        this.set('router', Ember.getOwner(this).lookup('router:main'));
    },

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
        },

        'password-reset': function() {
            this.get('router').transitionTo('users.password-reset', { queryParams: { email: this.get('email') }});
        }
    }
});
