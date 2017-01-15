import Ember from 'ember';

export function amountInDollars(params/*, hash*/) {
  return `${parseFloat(params).toFixed(2)}$`;
}

export default Ember.Helper.helper(amountInDollars);
