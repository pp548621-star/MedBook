<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="includes/header.jsp" />
<jsp:include page="includes/navbar.jsp" />

<!-- Hero Section -->
<section class="hero">
    <div class="hero-container">
        <div class="hero-content">
            <h1>The <span>Easiest</span> Way to Book Your Doctor Appointments</h1>
            <p>Connect with top healthcare professionals, schedule appointments in seconds, and manage your health journey with ease.</p>
            <div class="hero-buttons">
                <a href="register.jsp" class="btn btn-primary btn-lg"><i class="fa-solid fa-calendar-check"></i> Book Appointment Now</a>
                <a href="login.jsp" class="btn btn-outline btn-lg">Sign In</a>
            </div>
        </div>
        <div class="hero-image">
            <div class="hero-mockup">
                <div style="background: linear-gradient(135deg, #FF6B4A 0%, #FF8A6B 100%); height: 200px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                    <i class="fa-solid fa-calendar-days" style="font-size: 4rem; color: white;"></i>
                </div>
                <div style="display: flex; gap: 12px;">
                    <div style="flex: 1; background: var(--bg-light); padding: 16px; border-radius: 8px; text-align: center;">
                        <i class="fa-solid fa-user-doctor" style="font-size: 1.5rem; color: var(--primary); margin-bottom: 8px;"></i>
                        <p style="font-size: 0.8rem; margin: 0; font-weight: 600;">Find Doctors</p>
                    </div>
                    <div style="flex: 1; background: var(--bg-light); padding: 16px; border-radius: 8px; text-align: center;">
                        <i class="fa-solid fa-clock" style="font-size: 1.5rem; color: var(--success); margin-bottom: 8px;"></i>
                        <p style="font-size: 0.8rem; margin: 0; font-weight: 600;">Book Instantly</p>
                    </div>
                    <div style="flex: 1; background: var(--bg-light); padding: 16px; border-radius: 8px; text-align: center;">
                        <i class="fa-solid fa-shield-heart" style="font-size: 1.5rem; color: var(--info); margin-bottom: 8px;"></i>
                        <p style="font-size: 0.8rem; margin: 0; font-weight: 600;">Stay Healthy</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="section-header">
        <h2>Why Choose MedBook?</h2>
        <p>Experience healthcare booking reimagined with powerful features designed for your convenience</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">
                <i class="fa-solid fa-user-doctor"></i>
            </div>
            <h3>Expert Doctors</h3>
            <p>Access a diverse network of highly qualified and experienced medical professionals across all specialties.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">
                <i class="fa-solid fa-clock"></i>
            </div>
            <h3>24/7 Booking</h3>
            <p>Schedule your appointments anytime, anywhere. No more waiting on hold or during office hours.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">
                <i class="fa-solid fa-shield-halved"></i>
            </div>
            <h3>Secure & Private</h3>
            <p>Your medical data and personal information are encrypted and kept strictly confidential.</p>
        </div>
    </div>
</section>

<!-- How It Works Section -->
<section class="how-it-works">
    <div class="section-header">
        <h2>How It Works</h2>
        <p>Book your appointment in three simple steps</p>
    </div>
    <div class="steps-grid">
        <div class="step-card">
            <div class="step-number">1</div>
            <h3>Find a Doctor</h3>
            <p>Browse through our extensive list of verified healthcare professionals and specialists.</p>
        </div>
        <div class="step-card">
            <div class="step-number">2</div>
            <h3>Choose Date & Time</h3>
            <p>Select your preferred appointment slot from the available schedule.</p>
        </div>
        <div class="step-card">
            <div class="step-number">3</div>
            <h3>Confirm Booking</h3>
            <p>Get instant confirmation and reminders for your upcoming appointment.</p>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <h2>Ready to Get Started?</h2>
    <p>Join thousands of patients who trust MedBook for their healthcare needs</p>
    <a href="register.jsp" class="btn btn-primary btn-lg">Create Free Account</a>
</section>

<jsp:include page="includes/footer.jsp" />
