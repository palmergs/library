import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import Object from '@ember/object';

export default Route.extend(AuthenticatedRouteMixin, {
  model() {
    return Object.create({ title: '', isbn: '', publishDate: null, author: null });
  }
});
