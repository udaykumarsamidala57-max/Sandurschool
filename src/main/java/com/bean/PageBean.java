package com.bean;

import java.util.ArrayList;
import java.util.List;

public class PageBean {
    private Long id;
    private String title;
    private String slug;
    private List<Section> sections = new ArrayList<>();

    public PageBean() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }

    public List<Section> getSections() { return sections; }
    public void setSections(List<Section> sections) { this.sections = sections; }

    // --- Inner Class: Section ---
    public static class Section {
        private Long id;
        private Long pageId;
        private String sectionType;
        private Integer sequenceOrder;
        private String title;
        private String content;
        private List<SectionImage> images = new ArrayList<>();

        public Section() {}

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public Long getPageId() { return pageId; }
        public void setPageId(Long pageId) { this.pageId = pageId; }

        public String getSectionType() { return sectionType; }
        public void setSectionType(String sectionType) { this.sectionType = sectionType; }

        public Integer getSequenceOrder() { return sequenceOrder; }
        public void setSequenceOrder(Integer sequenceOrder) { this.sequenceOrder = sequenceOrder; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }

        public List<SectionImage> getImages() { return images; }
        public void setImages(List<SectionImage> images) { this.images = images; }
    }

    // --- Inner Class: SectionImage ---
    public static class SectionImage {
        private Long id;
        private Long sectionId;
        private byte[] imageData;
        private String imageType;
        private String altText;
        private Integer sequenceOrder;

        public SectionImage() {}

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }

        public Long getSectionId() { return sectionId; }
        public void setSectionId(Long sectionId) { this.sectionId = sectionId; }

        public byte[] getImageData() { return imageData; }
        public void setImageData(byte[] imageData) { this.imageData = imageData; }

        public String getImageType() { return imageType; }
        public void setImageType(String imageType) { this.imageType = imageType; }

        public String getAltText() { return altText; }
        public void setAltText(String altText) { this.altText = altText; }

        public Integer getSequenceOrder() { return sequenceOrder; }
        public void setSequenceOrder(Integer sequenceOrder) { this.sequenceOrder = sequenceOrder; }
    }
}