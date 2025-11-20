/**
 * Pattern Violation Detector
 *
 * Detects forbidden design patterns and enforces taste guardrails.
 * Prevents max-width: 800px, dead-center layouts, arbitrary values, etc.
 */
import fs from 'fs-extra';
import path from 'path';
export class PatternViolationDetector {
    schemaPath;
    schema;
    constructor(schemaPath = 'schemas/design-violations.json') {
        this.schemaPath = schemaPath;
    }
    /**
     * Load design violations schema
     */
    async loadSchema() {
        const fullPath = path.resolve(this.schemaPath);
        if (!await fs.pathExists(fullPath)) {
            throw new Error(`Design violations schema not found: ${fullPath}`);
        }
        this.schema = await fs.readJson(fullPath);
    }
    /**
     * Detect violations in code
     */
    async detect(code, filePath) {
        if (!this.schema) {
            await this.loadSchema();
        }
        const detected = [];
        // Check all categories
        for (const [categoryName, category] of Object.entries(this.schema.categories)) {
            for (const pattern of category.forbidden_patterns) {
                const violations = this.findPattern(code, pattern, categoryName, filePath);
                if (violations.instances > 0) {
                    detected.push(violations);
                }
            }
        }
        // Categorize by severity
        const result = {
            hasViolations: detected.length > 0,
            critical: detected.filter(v => v.severity === 'critical'),
            high: detected.filter(v => v.severity === 'high'),
            medium: detected.filter(v => v.severity === 'medium'),
            low: detected.filter(v => v.severity === 'low'),
            shouldBlock: false,
            summary: ''
        };
        // Determine if should block
        const blockingSeverities = this.schema.enforcement.blocking_severity;
        result.shouldBlock = detected.some(v => blockingSeverities.includes(v.severity));
        // Generate summary
        result.summary = this.generateSummary(result);
        return result;
    }
    /**
     * Detect violations in file
     */
    async detectInFile(filePath) {
        const absolutePath = path.resolve(filePath);
        if (!await fs.pathExists(absolutePath)) {
            throw new Error(`File not found: ${filePath}`);
        }
        const code = await fs.readFile(absolutePath, 'utf-8');
        return this.detect(code, filePath);
    }
    /**
     * Detect violations in multiple files
     */
    async detectInFiles(filePaths) {
        const results = new Map();
        for (const filePath of filePaths) {
            try {
                const result = await this.detectInFile(filePath);
                if (result.hasViolations) {
                    results.set(filePath, result);
                }
            }
            catch (error) {
                // Skip files that can't be read
                console.error(`Error checking ${filePath}:`, error);
            }
        }
        return results;
    }
    /**
     * Find pattern in code
     */
    findPattern(code, pattern, category, filePath) {
        try {
            const regex = new RegExp(pattern.pattern, 'g');
            const matches = code.match(regex) || [];
            const locations = [];
            if (matches.length > 0 && filePath) {
                // Find line numbers
                const lines = code.split('\n');
                lines.forEach((line, idx) => {
                    if (regex.test(line)) {
                        locations.push(`${filePath}:${idx + 1}`);
                    }
                });
            }
            return {
                ...pattern,
                category,
                instances: matches.length,
                locations
            };
        }
        catch (error) {
            // Invalid regex - skip
            return {
                ...pattern,
                category,
                instances: 0,
                locations: []
            };
        }
    }
    /**
     * Generate summary of violations
     */
    generateSummary(result) {
        if (!result.hasViolations) {
            return '✅ No pattern violations detected';
        }
        const lines = [];
        if (result.critical.length > 0) {
            lines.push(`🚫 CRITICAL (${result.critical.length}):`);
            result.critical.forEach(v => {
                lines.push(`   • ${v.violation}`);
                lines.push(`     Correct: ${v.correct}`);
                lines.push(`     Reason: ${v.reason}`);
            });
        }
        if (result.high.length > 0) {
            lines.push(`❌ HIGH (${result.high.length}):`);
            result.high.forEach(v => {
                lines.push(`   • ${v.violation}`);
                lines.push(`     Correct: ${v.correct}`);
            });
        }
        if (result.medium.length > 0) {
            lines.push(`⚠️  MEDIUM (${result.medium.length}):`);
            result.medium.forEach(v => {
                lines.push(`   • ${v.violation} (${v.instances} instances)`);
            });
        }
        if (result.low.length > 0) {
            lines.push(`ℹ️  LOW (${result.low.length}):`);
            result.low.forEach(v => {
                lines.push(`   • ${v.violation} (${v.instances} instances)`);
            });
        }
        if (result.shouldBlock) {
            lines.push('');
            lines.push('🚫 BLOCKED - Fix critical/high violations before proceeding');
        }
        return lines.join('\n');
    }
    /**
     * Format detailed report
     */
    formatDetailedReport(result) {
        if (!result.hasViolations) {
            return '✅ No pattern violations detected';
        }
        const lines = ['# Pattern Violations Report', ''];
        const addViolations = (violations, severityLabel, icon) => {
            if (violations.length === 0)
                return;
            lines.push(`## ${icon} ${severityLabel} (${violations.length} violations)`, '');
            violations.forEach((v, idx) => {
                lines.push(`### ${idx + 1}. ${v.violation}`);
                lines.push(`**Category**: ${v.category}`);
                lines.push(`**Instances**: ${v.instances}`);
                lines.push(`**Correct**: ${v.correct}`);
                lines.push(`**Reason**: ${v.reason}`);
                if (v.locations.length > 0) {
                    lines.push('**Locations**:');
                    v.locations.forEach(loc => lines.push(`  - ${loc}`));
                }
                lines.push('');
            });
        };
        addViolations(result.critical, 'CRITICAL', '🚫');
        addViolations(result.high, 'HIGH', '❌');
        addViolations(result.medium, 'MEDIUM', '⚠️');
        addViolations(result.low, 'LOW', 'ℹ️');
        if (result.shouldBlock) {
            lines.push('---');
            lines.push('');
            lines.push('## 🚫 Action Required');
            lines.push('');
            lines.push('This code is **BLOCKED** due to critical/high severity violations.');
            lines.push('Fix the violations listed above before proceeding.');
        }
        return lines.join('\n');
    }
    /**
     * Check if code passes (no blocking violations)
     */
    async passes(code) {
        const result = await this.detect(code);
        return !result.shouldBlock;
    }
    /**
     * Get blocking violations only
     */
    async getBlockingViolations(code) {
        const result = await this.detect(code);
        return [...result.critical, ...result.high];
    }
}
/**
 * CLI tool for checking files
 */
export async function checkFiles(filePaths) {
    const detector = new PatternViolationDetector();
    const results = await detector.detectInFiles(filePaths);
    if (results.size === 0) {
        console.log('✅ No violations detected in any files');
        process.exit(0);
    }
    let hasBlockingViolations = false;
    for (const [filePath, result] of results.entries()) {
        console.log(`\n${'='.repeat(80)}`);
        console.log(`File: ${filePath}`);
        console.log('='.repeat(80));
        console.log(detector.formatDetailedReport(result));
        if (result.shouldBlock) {
            hasBlockingViolations = true;
        }
    }
    if (hasBlockingViolations) {
        console.log('\n🚫 FAILED - Fix blocking violations before committing');
        process.exit(1);
    }
    else {
        console.log('\n⚠️  PASSED with warnings - Consider fixing medium/low violations');
        process.exit(0);
    }
}
