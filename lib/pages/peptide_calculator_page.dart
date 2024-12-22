import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peptide_calculator/painters/syringe_scale_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class PeptideCalculatorPage extends StatefulWidget {
  const PeptideCalculatorPage({super.key});

  @override
  PeptideCalculatorPageState createState() => PeptideCalculatorPageState();
}

class PeptideCalculatorPageState extends State<PeptideCalculatorPage> {
  String? selectedSyringeVolume;
  String? selectedPeptideQuantity;
  String? selectedWaterVolume;
  String? selectedDosage;
  String? selectedDosageUnit = 'mg';
  String? enteredPeptideQuantity;
  String? enteredWaterVolume;
  String? enteredDosage;
  String result = '';
  Widget? resultWidget;
  double syringeUnits = 0.0;

  final syringeVolumes = ['0.3 ml (30 units)', '0.5 ml (50 units)', '1.0 ml (100 units)'];
  final syringeVolumeImages = [
    'assets/images/0.3ml_syringe.png',
    'assets/images/0.5ml_syringe.png',
    'assets/images/1ml_syringe.png',
  ];
  final peptideQuantities = ['5 mg', '10 mg', '15 mg', 'Other'];
  final peptideImage = 'assets/images/lyophilized_powder.png';
  final waterVolumes = ['1 ml', '2 ml', '3 ml', '5 ml', 'Other'];
  final waterImage = 'assets/images/bacteriostatic_water.png';
  final dosages = ['50 mcg', '100 mcg', '250 mcg', '500 mcg', '1 mg', '2.5 mg', '5 mg', '10 mg', 'Other'];

  // Function to recalculate and update the result
  void calculateSyringeUnits() {
    // Parse user inputs safely, checking for null and providing defaults
    double peptideQuantity = selectedPeptideQuantity == 'Other'
        ? double.tryParse(enteredPeptideQuantity ?? '0') ?? 0.0
        : double.tryParse(selectedPeptideQuantity?.split(' ')[0] ?? '0') ?? 0.0;

    double waterVolume = selectedWaterVolume == 'Other'
        ? double.tryParse(enteredWaterVolume ?? '0') ?? 0.0
        : double.tryParse(selectedWaterVolume?.split(' ')[0] ?? '0') ?? 0.0;

    double desiredDose = selectedDosage == 'Other'
        ? double.tryParse(enteredDosage ?? '0') ?? 0.0
        : double.tryParse(selectedDosage?.split(' ')[0] ?? '0') ?? 0.0;

    // Convert pre-given dosage (mcg to mg) if the dosage is in mcg
    if (selectedDosage != null && selectedDosage!.contains('mcg')) {
      desiredDose /= 1000.0; // Convert mcg to mg
    }

    // Convert micrograms to milligrams for all cases
    if (selectedDosageUnit == 'mcg') {
      desiredDose /= 1000.0;
    }

    // Validate inputs before proceeding
    if (peptideQuantity <= 0.0 || waterVolume <= 0.0 || desiredDose <= 0.0) {
      setState(() {
        result = 'Invalid input values. Please review your selections.';
        resultWidget = Text(result, style: Theme.of(context).textTheme.bodyLarge,); // Simple error message
      });
      return;
    }

    // Calculate concentration
    double concentration = peptideQuantity / waterVolume;

    // Calculate volume to draw
    double volumeToDraw = desiredDose / concentration;

    // Determine syringe scaling factor
    double syringeScalingFactor = 100;

    // Calculate syringe units
      setState(() {
    syringeUnits = volumeToDraw * syringeScalingFactor;
  });
    
    // Format the research dose to match user input
    String formattedDose = selectedDosage == 'Other'
        ? '${enteredDosage ?? '0'} ${selectedDosageUnit ?? 'mg'}'
        : selectedDosage!;

    // Update the result with the rich text widget
    setState(() {
      resultWidget = RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyLarge, // Default secondary font
          children: <TextSpan>[
            const TextSpan(
              text: 'For a research dose of ',
            ),
            TextSpan(
              text: formattedDose,
              style: const TextStyle(
                color: Color.fromRGBO(236, 72, 153, 1.0), // Color for the dose
                fontFamily: 'Halyard_Display',
              ),
            ),
            const TextSpan(
              text: ', fill the syringe to ', // Default secondary font
            ),
            TextSpan(
              text: syringeUnits.toStringAsFixed(1),
              style: const TextStyle(
                color: Color.fromRGBO(236, 72, 153, 1.0), // Color for syringe units
                fontFamily: 'Halyard_Display',
              ),
            ),
            const TextSpan(
              text: ' units. ', // Default secondary font
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    double totalUnits = selectedSyringeVolume == '0.3 ml (30 units)'
        ? 30
        : selectedSyringeVolume == '0.5 ml (50 units)'
            ? 50
            : 100; // Default for 1.0 ml syringe

    return Scaffold(
      appBar: AppBar(
        title: Text('Peptide Calculator', style: Theme.of(context).textTheme.titleLarge,), // Title in primary font
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
              heightFactor: 1.25,
              child: ElevatedButton(
                onPressed: () {
                  // Replace with your desired URL
                  const url = 'https://www.fitandfab812.com/';
                  // Launch the URL
                  _launchURL(url);
                },
                child: Text(
                  'Visit Our Website',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color.fromRGBO(227, 50, 121, 1.0) // Change to your desired color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
              Text('What is the total volume of your syringe?', style: Theme.of(context).textTheme.bodyLarge), // Questions in secondary font
              Column(
                children: List.generate(syringeVolumes.length, (index) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: syringeVolumes[index],
                        groupValue: selectedSyringeVolume,
                        activeColor: const Color.fromRGBO(229, 112, 147, 0.9),
                        onChanged: (value) {
                          setState(() {
                            selectedSyringeVolume = value;
                            calculateSyringeUnits(); // Calculate on selection
                          });
                        },
                      ),
                      Text(syringeVolumes[index], style: Theme.of(context).textTheme.bodyLarge), // Options in secondary font
                      const SizedBox(width: 30),
                      Image.asset(
                      syringeVolumeImages[index],
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.1,
                        fit: BoxFit.contain,
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              Text('What is the total quantity of peptide in the vial?', style: Theme.of(context).textTheme.bodyLarge),
              Row(
                children: [
                  Column(
                    children: peptideQuantities.map((quantity) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: quantity,
                            groupValue: selectedPeptideQuantity,
                            activeColor: const Color.fromRGBO(229, 112, 147, 0.9),
                            onChanged: (value) {
                              setState(() {
                                selectedPeptideQuantity = value;
                                calculateSyringeUnits(); // Calculate on selection
                              });
                            },
                          ),
                          Text(quantity, style: Theme.of(context).textTheme.bodyLarge), // Options in secondary font
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 90),
                  Image.asset(
                    peptideImage,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.contain
                  ),
                ],
              ),
              if (selectedPeptideQuantity == 'Other')
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter peptide quantity (mg)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    enteredPeptideQuantity = value;
                    calculateSyringeUnits(); // Calculate on change
                  },
                ),
              const SizedBox(height: 16),
              Text('How much bacteriostatic water will be added?', style: Theme.of(context).textTheme.bodyLarge),
              Row(
                children: [
                  Column(
                    children: waterVolumes.map((volume) {
                      return Row(
                        children: [
                          Radio<String>(
                            value: volume,
                            groupValue: selectedWaterVolume,
                            activeColor: const Color.fromRGBO(229, 112, 147, 0.9),
                            onChanged: (value) {
                              setState(() {
                                selectedWaterVolume = value;
                                calculateSyringeUnits(); // Calculate on selection
                              });
                            },
                          ),
                          Text(volume, style: Theme.of(context).textTheme.bodyLarge), // Options in secondary font
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 90),
                  Image.asset(
                    waterImage,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              if (selectedWaterVolume == 'Other')
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter water volume (ml)'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    enteredWaterVolume = value;
                    calculateSyringeUnits(); // Calculate on change
                  },
                ),
              const SizedBox(height: 16),
              Text('What is the desired research dosage for the peptide?', style: Theme.of(context).textTheme.bodyLarge),
              Column(
                children: dosages.map((dosage) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: dosage,
                        groupValue: selectedDosage,
                        activeColor: const Color.fromRGBO(229, 112, 147, 0.9),
                        onChanged: (value) {
                          setState(() {
                            selectedDosage = value;
                            if (value!= 'Other') {
                              selectedDosageUnit = 'mg'; //Reset Unit to mg
                              enteredDosage = null ;
                            }
                            calculateSyringeUnits(); // Calculate on selection
                          });
                        },
                      ),
                      Text(dosage, style: Theme.of(context).textTheme.bodyLarge), // Options in secondary font
                    ],
                  );
                }).toList(),
              ),
              if (selectedDosage == 'Other') ...{
                TextField(
                  decoration: const InputDecoration(hintText: 'Enter dosage'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    enteredDosage = value;
                    calculateSyringeUnits(); // Calculate on change
                  },
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'mg',
                      groupValue: selectedDosageUnit,
                      activeColor: const Color.fromRGBO(229, 112, 147, 0.9),
                      onChanged: (value) {
                         setState(() {
                           selectedDosageUnit = value;
                          calculateSyringeUnits(); // Calculate on selection
                        });
                      },
                    ),
                    Text('mg', style: Theme.of(context).textTheme.bodyLarge),
                    Radio<String>(
                      value: 'mcg',
                      groupValue: selectedDosageUnit,
                      activeColor: const Color.fromRGBO(229, 112, 147, 0.9),
                      onChanged: (value) {
                        setState(() {
                          selectedDosageUnit = value;
                          calculateSyringeUnits(); // Calculate on selection
                        });
                      },
                    ),
                    Text('mcg', style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
  },
              const SizedBox(height: 16),
              if (resultWidget != null) resultWidget!,

        // Adding the scale
        SizedBox(
          height: 75,
          child: CustomPaint(
            painter: ScalePainter(
              syringeUnits: syringeUnits, // Pass the calculated syringe units
              scalingFactor: totalUnits,
              themeData: Theme.of(context), // Pass the volume of the syringe
              ),
              size: Size(MediaQuery.of(context).size.width, 100), // Dynamically adapt to screen width
              ),
              ),
            
            
             // New Socials and Contact Section
              const Divider(thickness: 1),
              const SizedBox(height: 8),
              Text(
                'Connect with us:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: [
                      GestureDetector(
      onTap: () => _launchURL('https://www.facebook.com/fitandfab812llc'),
      child: Image.asset(
        'assets/images/facebook.png',
        width: 40,
        height: 40,
      ),
    ),
    GestureDetector(
      onTap: () => _launchURL('https://x.com/fitandfab812'),
      child: Image.asset(
        'assets/images/x.png',
        width: 40,
        height: 40,
      ),
    ),
    GestureDetector(
      onTap: () => _launchURL('https://www.tiktok.com/@fitandfab812llc'),
      child: Image.asset(
        'assets/images/tiktok.png',
        width: 40,
        height: 40,
      ),
    ),
    GestureDetector(
      onTap: () => _launchURL('https://www.instagram.com/fitandfab812'),
      child: Image.asset(
        'assets/images/instagram.png',
        width: 40,
        height: 40,
      ),
    ),
    GestureDetector(
      onTap: () => _launchURL('https://www.youtube.com/@fitandfab812'),
      child: Image.asset(
        'assets/images/youtube.png',
        width: 40,
        height: 40,
      ),
    ),
    GestureDetector(
      onTap: () => _launchURL('https://www.pinterest.com/fitandfab812/'),
      child: Image.asset(
        'assets/images/pinterest.png',
        width: 40,
        height: 40,
      ),
    ),
    
                      // IconButton(
                      //   icon: const Icon(Icons.email, color: Colors.green),
                      //   onPressed: () => _launchURL('mailto:info@fitandfab812.com'),
                      // ),
                      // IconButton(
                      //   icon: const Icon(Icons.phone, color: Colors.green),
                      //   onPressed: () => _launchURL('tel:18125300765'),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),

                   Text(
                    'Contact us:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16.0,
                    runSpacing: 8.0,
                    children: [
                      GestureDetector(
      onTap: () => _launchURL('mailto:info@fitandfab812.com'),
      child: Image.asset(
        'assets/images/mail.png',
        width: 40,
        height: 40,
      ),
    ),

    // Phone Number
                  
                    GestureDetector(
      onTap: () => _launchURL('tel:18125300765'),
      child: Image.asset(
        'assets/images/phone.png',
        width: 40,
        height: 40,
      ),
    ),
    GestureDetector(
      onTap: () => _launchURL('https://wa.me/18125300765'),
      child: Image.asset(
        'assets/images/whatsapp.png',
        width: 40,
        height: 40,
      ),
    ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  
                  
                  
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else if (mounted) {
    // Display an error message in case of failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not launch $url'),
      ),
    );
  }
}
}
