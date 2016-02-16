import Ember from 'ember';

export default Ember.Component.extend({
  copyrightYear: Ember.computed(function() {
    return new Date().getFullYear();
  })
});
