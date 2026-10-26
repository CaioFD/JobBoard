// Create Job button: only shown to admins (the backend still has to check the role when saving a job)
if (getUser()?.role === 'admin') document.getElementById('create_job_btn').hidden = false;

// Favorite job
document.querySelectorAll('.bookmark').forEach(btn => {
  btn.addEventListener('click', () => {
    btn.setAttribute('aria-pressed', btn.getAttribute('aria-pressed') !== 'true');
  });
});

// Show More / Show Less 
const showMore = document.getElementById('show_more');
showMore.addEventListener('click', () => {
  const extras = document.querySelectorAll('#category_list .extra');
  const open = extras[0].hidden;
  extras.forEach(li => li.hidden = !open);
  showMore.textContent = open ? 'Show Less' : 'Show More';
});

const [minRange, maxRange] = document.querySelectorAll('#salary_range input');
const salaryValue = document.getElementById('salary_value');

function updateSalary(e) {
  if (+minRange.value > +maxRange.value) {
    e.target === minRange ? minRange.value = maxRange.value : maxRange.value = minRange.value;
  }
  salaryValue.textContent = `$${minRange.value} - $${maxRange.value}`;
}

minRange.addEventListener('input', updateSalary);
maxRange.addEventListener('input', updateSalary);
