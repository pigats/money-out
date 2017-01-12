import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
    email: DS.attr('string'),
    'avatar-url': DS.attr('string'),
    password: DS.attr('string'),
    role: DS.attr('number', { defaultValue: 0 }),
    expenses: DS.hasMany('expense', {async: true}),

    'is-user-admin': Ember.computed('role', function() {
        return this.get('role') > 0;
    }),

    'is-admin': Ember.computed('role', function() {
        return this.get('role') > 1;
    }),

    'role-in-words': Ember.computed('role', function() {
        return this.roleInWords(this.get('role'));
    }),

    'assigner-of-roles': Ember.computed('role', function() {
        const roles = [];
        for(let i = 0, l = this.get('role'); i <= l; i += 1) {
            roles.push({ value: i, name: this.roleInWords(i) });
        }
        return roles;
    }),

    roleInWords(roleId) {
        switch(roleId) {
            case 0: return 'user';
            case 1: return 'users admin';
            case 2: return 'admin';
        }
    }

});
