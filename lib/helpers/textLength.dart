  String truncateTitle(String title) {
    // Replace this with your logic to truncate the title
    const int maxTitleLength = 20;
    if (title.length > maxTitleLength) {
      return '${title.substring(0, maxTitleLength)}...';
    }
    return title;
  }