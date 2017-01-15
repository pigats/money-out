import Ember from 'ember';

export default Ember.Component.extend({
    me: Ember.inject.service('current-user'),

    actions: {
        deleteUser(user) {
            this.sendAction('delete', user);
        }
    }
});
