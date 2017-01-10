import DS from 'ember-data';

export default DS.Model.extend({
    email: DS.attr('string'),
    'avatar-url': DS.attr('string'),
    password: DS.attr('string'),
    expenses: DS.hasMany('expense', {async: true})
});
