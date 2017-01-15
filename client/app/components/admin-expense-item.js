import ExpenseItem from './expense-item';
import Ember from 'ember';

export default ExpenseItem.extend({
    me: Ember.inject.service('current-user'),
});
