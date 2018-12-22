import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    deleteAuthor(author) {
      author.deleteRecord();
      author.save().then(() => {
        this.transitionToRoute('author.index');
      });
    }
  }
});
