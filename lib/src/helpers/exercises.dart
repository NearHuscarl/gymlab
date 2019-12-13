bool filterName(List<String> searchTerms, String name, List<String> keywords) {
  return searchTerms.every((term) {
    return name.contains(term) || keywords.any((kw) => kw.contains(term));
  });
}
