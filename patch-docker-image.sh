#!/bin/bash
sed -i '/- name: Build and push/i \
      - name: Build and load\
        uses: docker/build-push-action@v7\
        with:\
          context: .\
          build-args: |\
            TYPST_VERSION=${{ github.ref_name }}\
          load: true\
          tags: test-typst:latest\
\
      - name: Test image\
        run: |\
          echo "Hello World!" > test.typ\
          docker run --rm -v ${{ github.workspace }}:/workspace -w /workspace test-typst:latest typst compile test.typ\
          ls -l test.pdf\
          docker run --rm test-typst:latest typst --version\
' .github/workflows/docker-image.yml
