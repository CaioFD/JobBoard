const yearsField = document.getElementById('years_field');
const yearsSelect = document.getElementById('experience_years');

document.querySelectorAll('input[name="experience"]').forEach(radio => {
    radio.addEventListener('change', () => {
        const needsExperience = radio.value === 'required';
        yearsField.hidden = !needsExperience;
        yearsSelect.required = needsExperience;
        if (!needsExperience) yearsSelect.value = '';
    });
});

// shortcut: Add button does nothing yet, wire it to the backend API once it exists
document.getElementById('job_form').addEventListener('submit', e => e.preventDefault());
