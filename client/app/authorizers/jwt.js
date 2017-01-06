import Base from 'ember-simple-auth/authorizers/base';
import Ember from 'ember';

export default Base.extend({
    session: Ember.inject.service('session'),

    authorize(data, block) {
        if(this.get('session.isAuthenticated') && data.token) {
            block('Authorization', `Bearer ${data.token}`);
        }
    }
});
