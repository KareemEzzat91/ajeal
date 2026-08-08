import 'package:flutter/material.dart';
import 'package:ajeal/helpers/generated/l10n.dart';
import '../models/add_child_form_state.dart';
import 'form_helpers.dart';

class MedicalHistorySection extends StatelessWidget {
  final AddChildFormState formState;

  const MedicalHistorySection({
    super.key,
    required this.formState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormSectionWidget(
          title: S.of(context).healthHistory,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.vaccinationsController,
              label: S.of(context).vaccinations,
              icon: Icons.vaccines,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.measlesController,
              label: S.of(context).measles,
              icon: Icons.sick,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.smallpoxController,
              label: S.of(context).smallpox,
              icon: Icons.sick_outlined,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.medicationsController,
              label: S.of(context).medications,
              icon: Icons.medication,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).firstYearGrowth,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.teethingController,
              label: S.of(context).teething,
              icon: Icons.child_care,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.babblingController,
              label: S.of(context).babbling,
              icon: Icons.record_voice_over,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.motherVoiceAttentionController,
              label: S.of(context).attentionToMothersVoice,
              icon: Icons.hearing,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.sittingAloneController,
              label: S.of(context).sittingAlone,
              icon: Icons.airline_seat_recline_normal,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.crawlingController,
              label: S.of(context).crawling,
              icon: Icons.directions_walk,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.walkingController,
              label: S.of(context).walking,
              icon: Icons.directions_run,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.handPointingController,
              label: S.of(context).handPointing,
              icon: Icons.touch_app,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).psychologicalHistory,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.familyDisabilitiesController,
              label: S.of(context).familyDisabilities,
              icon: Icons.psychology,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).socialHistory,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.socialInteractionController,
              label: S.of(context).socialInteraction,
              icon: Icons.people,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.parentAbsenceController,
              label: S.of(context).parentAbsence,
              icon: Icons.family_restroom,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).medicalExaminations,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.hearingController,
              label: S.of(context).hearing,
              icon: Icons.hearing,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.visionController,
              label: S.of(context).vision,
              icon: Icons.visibility,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.respiratoryController,
              label: S.of(context).respiratory,
              icon: Icons.air,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.digestiveController,
              label: S.of(context).digestive,
              icon: Icons.restaurant,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.neurologyController,
              label: S.of(context).neurology,
              icon: Icons.psychology,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.circulatoryController,
              label: S.of(context).circulatory,
              icon: Icons.favorite,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.vocalController,
              label: S.of(context).vocal,
              icon: Icons.mic,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).oralExamination,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.headController,
              label: S.of(context).head,
              icon: Icons.face,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.speechController,
              label: S.of(context).speech,
              icon: Icons.record_voice_over,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.lipsController,
              label: S.of(context).lips,
              icon: Icons.mood,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.teethController,
              label: S.of(context).teeth,
              icon: Icons.tag_faces,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.palateController,
              label: S.of(context).palate,
              icon: Icons.face_retouching_natural,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.tongueController,
              label: S.of(context).tongue,
              icon: Icons.face_2,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.upperJawController,
              label: S.of(context).upperJaw,
              icon: Icons.sentiment_neutral,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.lowerJawController,
              label: S.of(context).lowerJaw,
              icon: Icons.sentiment_neutral,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.pharynxController,
              label: S.of(context).pharynx,
              icon: Icons.masks,
            ),
            const SizedBox(height: 16),
            AnimatedTextFieldWidget(
              controller: formState.throatController,
              label: S.of(context).throat,
              icon: Icons.sick,
            ),
          ],
        ),
        FormSectionWidget(
          title: S.of(context).diagnosis,
          children: [
            AnimatedTextFieldWidget(
              controller: formState.diagnosisController,
              label: S.of(context).diagnosis,
              icon: Icons.medical_information,
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }
}
