import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/models/visit_context.dart';

class VisitContextSheet extends StatefulWidget {
  final VisitContext initial;

  const VisitContextSheet({super.key, required this.initial});

  @override
  State<VisitContextSheet> createState() => _VisitContextSheetState();
}

class _VisitContextSheetState extends State<VisitContextSheet> {
  VisitWith? _withWhom;
  CautionLevel? _caution;

  @override
  void initState() {
    super.initState();
    _withWhom = widget.initial.withWhom;
    _caution = widget.initial.caution;
  }

  void _apply() {
    Navigator.of(
      context,
    ).pop(VisitContext(withWhom: _withWhom, caution: _caution));
  }

  void _clear() {
    setState(() {
      _withWhom = null;
      _caution = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Tell me about this visit",
                      style: t.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(widget.initial),
                    icon: const Icon(Icons.close),
                    tooltip: "Close",
                  ),
                ],
              ),

              const SizedBox(height: 14),
              Text(
                "Who is this visit for?",
                style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _chip(
                    context,
                    label: "Just me",
                    selected: _withWhom == VisitWith.justMe,
                    onTap: () => setState(() => _withWhom = VisitWith.justMe),
                  ),
                  _chip(
                    context,
                    label: "Friends",
                    selected: _withWhom == VisitWith.friends,
                    onTap: () => setState(() => _withWhom = VisitWith.friends),
                  ),
                  _chip(
                    context,
                    label: "Date",
                    selected: _withWhom == VisitWith.date,
                    onTap: () => setState(() => _withWhom = VisitWith.date),
                  ),
                  _chip(
                    context,
                    label: "Family",
                    selected: _withWhom == VisitWith.family,
                    onTap: () => setState(() => _withWhom = VisitWith.family),
                  ),
                ],
              ),

              const SizedBox(height: 18),
              Text(
                "How cautious do you feel right now?",
                style: t.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _chip(
                    context,
                    label: "Relaxed",
                    selected: _caution == CautionLevel.relaxed,
                    onTap: () =>
                        setState(() => _caution = CautionLevel.relaxed),
                  ),
                  _chip(
                    context,
                    label: "Balanced",
                    selected: _caution == CautionLevel.balanced,
                    onTap: () =>
                        setState(() => _caution = CautionLevel.balanced),
                  ),
                  _chip(
                    context,
                    label: "Very cautious",
                    selected: _caution == CautionLevel.cautious,
                    onTap: () =>
                        setState(() => _caution = CautionLevel.cautious),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: _clear, child: const Text("Clear")),
                  FilledButton(onPressed: _apply, child: const Text("Apply")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
