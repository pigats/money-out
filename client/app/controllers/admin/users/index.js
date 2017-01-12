import Ember from 'ember';

export default Ember.Controller.extend({
    me: Ember.inject.service('current-user'),

    actions: {
        deleteUser(user) {
            if(window.confirm(`Are you sure you want to delete ${user.get('email')} and all their expenses?`)) {
                user.destroyRecord();
            }
        }
    }
});
