import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),
    roles: Ember.computed('me', function() {
        return this.get('me').get('user.assigner-of-roles');
    }),

    actions: {

        createUser(user) {
            user.save().then(() =>
                this.transitionToRoute('admin.users.index')
            );
        }
    }
});
