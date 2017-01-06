import Ember from 'ember';

export default Ember.Component.extend({
    session: Ember.inject.service('session'),
    me: Ember.inject.service('current-user')
});
