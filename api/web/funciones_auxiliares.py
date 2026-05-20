import html


def sanitize_field(data):
    if isinstance(data, str):
        return html.escape(data)
    if isinstance(data, dict):
        return {k: sanitize_field(v) for k, v in data.items()}
    if isinstance(data, list):
        return [sanitize_field(v) for v in data]
    return data


def prepare_response_extra_headers(is_json=True):
    headers = {
        'X-Content-Type-Options': 'nosniff',
        'X-Frame-Options': 'DENY',
        'X-XSS-Protection': '1; mode=block',
        'Referrer-Policy': 'strict-origin-when-cross-origin',
        'Permissions-Policy': 'geolocation=(), microphone=(), camera=()',
        'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
        'Cache-Control': 'no-store',
    }
    if is_json:
        headers['Content-Security-Policy'] = "default-src 'none'; frame-ancestors 'none'"
    return headers