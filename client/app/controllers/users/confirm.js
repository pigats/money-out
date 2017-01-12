import Ember from 'ember';

export default Ember.Controller.extend({

    actions: {
        confirmUser() {
            this.get('model').save({adapterOptions: {confirm: true}})
                .then(() => this.transitionToRoute('expenses.index'))
                .catch(error => {
                    if(error.errors && +error.errors[0].status === 403) {
                        this.set('email-confirm-token-error', 'unrecognized or expired');
                    } else {
                        throw error;
                    }
                });
        }
    }
});
