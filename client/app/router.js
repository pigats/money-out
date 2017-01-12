import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('users', function() {
    this.route('new');
    this.route('edit');
    this.route('password-reset');
  });
  this.route('expenses', function() {
    this.route('new');
    this.route('edit', { path: ':expense_id/edit' });
  });
  this.route('login');

  this.route('admin', function() {
    this.route('users', function() {
      this.route('new');
      this.route('edit', { path: ':user_id/edit' });
    });
    this.route('expenses', function() {
      this.route('new');
      this.route('edit', { path: ':expense_id/edit' });
    });
  });
});

export default Router;
