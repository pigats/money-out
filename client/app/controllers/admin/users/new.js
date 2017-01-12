import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),
    roles: Ember.computed('me', function() {
        return this.get('me').get('user.assigner-of-roles');
    }),

    actions: {

        createUser(params) {
            this.set('model.email', params.get('email'));
            this.set('model.password', params.get('password'));
            this.set('model.role', params.get('role'));

            this.get('model').save().then(() =>
                this.transitionToRoute('admin.users.index')
            );
        }
    }
});
