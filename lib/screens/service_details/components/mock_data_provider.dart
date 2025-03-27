class MockDataProvider {
  static List<Map<String, dynamic>> getReviews() {
    return [
      {
        'name': 'Raj Sharma',
        'rating': 5.0,
        'comment': 'Excellent service! The technician was knowledgeable and fixed my system quickly.',
        'date': '2 weeks ago',
      },
      {
        'name': 'Priya Patel',
        'rating': 4.5,
        'comment': 'Very professional team. They cleaned all my solar panels thoroughly.',
        'date': '1 month ago',
      },
      {
        'name': 'Amit Singh',
        'rating': 4.0,
        'comment': 'Good service but arrived a bit late. Otherwise very satisfactory.',
        'date': '2 months ago',
      },
      {
        'name': 'Neha Gupta',
        'rating': 5.0,
        'comment': 'Amazing service! The team was punctual and very professional.',
        'date': '3 months ago',
      },
      {
        'name': 'Vikram Reddy',
        'rating': 4.0,
        'comment': 'They did a good job. My system is working much better now.',
        'date': '3 months ago',
      },
    ];
  }

  static List<Map<String, String>> getFAQs(String serviceDuration) {
    return [
      {
        'question': 'How often should I clean my solar panels?',
        'answer': 'For optimal performance, we recommend cleaning your solar panels every 3-6 months, depending on your location and environmental factors like dust, pollution, and bird droppings.',
      },
      {
        'question': 'What happens during a maintenance service visit?',
        'answer': 'Our technicians will inspect the entire system, clean panels, check wiring and connections, inspect the inverter performance, and provide a detailed health report with recommendations.',
      },
      {
        'question': 'How long does the service take?',
        'answer': 'Most of our services take between 1-4 hours depending on the size of your system and the specific service being performed. The estimated duration for this service is $serviceDuration.',
      },
      {
        'question': 'Do I need to be present during the service?',
        'answer': 'While it\'s not mandatory, we recommend that you or someone familiar with your system is present at least at the beginning and end of the service for a brief discussion with our technician.',
      },
      {
        'question': 'Is there any warranty for this service?',
        'answer': 'Yes, all our services come with a 30-day satisfaction guarantee. If you encounter any issues related to the service within this period, we\'ll fix it at no additional cost.',
      },
    ];
  }
}
