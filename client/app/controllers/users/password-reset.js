import Ember from 'ember';

export default Ember.Controller.extend({
    session: Ember.inject.service('session'),
    'has-token-already': false,

    actions: {
        createPasswordResetToken() {
            if(!Ember.isEmpty(this.get('model.email'))) {
                this.get('model').save().finally(() => this.toggleProperty('has-token-already', true));
            }
        },

        resetPassword() {
            this.get('model').save({adapterOptions: {method: 'patch'}})
                .then(() => this.transitionToRoute('login'))
                .catch(error => {
                    if(error.errors && +error.errors[0].status === 404) {
                        this.set('password-reset-token-error', 'unrecognized or expired');
                    } else {
                        throw error;
                    }
                });
        }
    }
});
