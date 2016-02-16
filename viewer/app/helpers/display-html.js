import Ember from 'ember';

/*
Generally unwise to do this, but we trust this data as it comes from our
build system
 */
export function displayHtml(params/*, hash*/) {
  return Ember.String.htmlSafe(`${params[0]}`);
}

export default Ember.Helper.helper(displayHtml);
