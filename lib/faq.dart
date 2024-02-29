import 'package:flutter/material.dart';
import 'package:thingspeak/main.dart';

class Faq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FAQPage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
    );
  }
}

class FAQPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'What are household gas emissions?',
      answer:
      'Household gas emissions refer to the release of gases from various sources within a home environment, such as cooking appliances, heating systems, and combustion processes.',
    ),
    FAQItem(
      question: 'Why are household gas emissions a concern?',
      answer:
      'Gas emissions can contribute to indoor air pollution, leading to health problems such as respiratory issues, headaches, and in severe cases, carbon monoxide poisoning. Additionally, these emissions contribute to outdoor air pollution and climate change.',
    ),
    FAQItem(
      question: 'Where can I find more information about household gas emissions and safety?',
      answer:
      'Refer to your local gas provider\'s website, government agencies responsible for environmental and health regulations, or consult with professional HVAC technicians for personalized advice and assistance.',
    ),
    FAQItem(
      question: 'What should I do if I suspect my gas appliances are not operating efficiently?',
      answer:
      'If you suspect your gas appliances are not operating efficiently, it is essential to schedule an inspection by a qualified technician. Faulty appliances can emit harmful gases and pose serious safety risks.',
    ),
    FAQItem(
      question: 'What are the health risks associated with household gas emissions?',
      answer:
      'Exposure to household gas emissions can lead to a variety of health risks, including respiratory issues, headaches, nausea, dizziness, and in severe cases, carbon monoxide poisoning. It is crucial to ensure proper ventilation and maintenance of gas appliances to minimize these risks.',
    ),
    FAQItem(
      question: 'How often should I have my gas appliances inspected?',
      answer:
      'It is recommended to have your gas appliances inspected annually by a qualified technician. Regular inspections can help ensure that your appliances are operating safely and efficiently, reducing the risk of gas leaks and other hazards.',
    ),
    FAQItem(
      question: 'Are there any warning signs of a gas leak in my home?',
      answer:
      'Yes, there are several warning signs of a gas leak in your home, including a sulfur-like odor (often described as a "rotten egg" smell), hissing sounds near gas appliances, dead or dying vegetation near gas lines, and physical symptoms such as headaches, dizziness, nausea, or fatigue. If you suspect a gas leak, evacuate the area immediately and contact your gas provider and emergency services.',
    ),
    // Add more FAQ items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),

      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => YourWidget()),
          );// This will pop the current route and take you to the previous page
        },
      ),
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: Text(faqItems[index].question),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(faqItems[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
